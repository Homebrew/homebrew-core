class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6c2e543baadc3bf2cdaf44fe1e916e0c27501a333ddc56f15ee0aea5ace90cb3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78ff8652a90cb8d32de04aa6809e9e6c2561eb3c3cbdda338e715b316ccc96ff"
    sha256 cellar: :any,                 arm64_sonoma:  "a0de976f21af591c1c6d9eebf189dd7331ba73ec0696158a1c63a466af50cdd8"
    sha256 cellar: :any,                 arm64_ventura: "cbcf0183338dd2c1fe828751be9beff628b463dc9823de6663d862f880b9d3b3"
    sha256 cellar: :any,                 sonoma:        "63ffceae04fa1e06412b6f3ac9d0d31add503b6640024d0c36884dbb6b7968da"
    sha256 cellar: :any,                 ventura:       "d4b44ff2c60a65e49040aa6f8d1caac6ffab4a762420fdb1fe85afd1221487bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cc23104260e5ccc7ae875eae176fbcba7505970217a200c2ceaee3e97ececbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3e2a9cb0a69adb19eb0deb11f5ae79b24830ae17e0eb12120622fa60de017e"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    %w[forge cast anvil chisel].each do |binary|
      system "cargo", "install", *std_cargo_args(path: "crates/#{binary}")

      # https://book.getfoundry.sh/config/shell-autocompletion
      generate_completions_from_executable(bin/binary.to_s, "completions") if binary != "chisel"

      system "help2man", bin/binary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath/"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin/"forge", "init"
      assert_path_exists project/"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}/forge test")
    end

    assert_match "Decimal: 2\n", pipe_output(bin/"chisel", "1+1")

    anvil_port = free_port
    anvil = spawn bin/"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end
