class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "cf4a21092f2cd29acf03aaab45233ff5703d38cd7b136d90bd118213562def94"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a35da0906034cb7c70eefac70a87757f07d7558c5c354d615b00acb5406f963"
    sha256 cellar: :any,                 arm64_sonoma:  "78c9103bff047747dc3c80dbca809cec0e6491a8aea5509d0fe53042a7e12825"
    sha256 cellar: :any,                 arm64_ventura: "d9fc3e66d66a881e705fd184229f13ee982a2fc87d85a4e5a1b71b4bbc1ef302"
    sha256 cellar: :any,                 sonoma:        "9285b6e12a6feb82923c9dd184217d772378dd7a1ae4cd70d8f763ae2f335833"
    sha256 cellar: :any,                 ventura:       "d923a4b381ddb6b6553d1bc54eff1249176f6d6c02ff79781be731f36de3f3be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c21e5271fb8ad752efebfb3759a2295f8985f449b24e8a68f6ef8b36119e6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4e713ea97c234b4322b699f01f75af290ebae92b7f04330ecf291e9e9152e7"
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
