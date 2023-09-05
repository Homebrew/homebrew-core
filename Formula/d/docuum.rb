class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/v0.23.0.tar.gz"
  sha256 "831ca0578d5b1a260b766682b2d7f0b072c59d213d10f4bc89955e8169816faf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "487459e1edf993afd30aaff3646de91f17e28232876a109b2d2cad966ba205aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e7c687447d4bc44f5f3530ef32505ab4794175bd7f27e545d32d65eaee11c77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436afaec62095e1e894b8f2b48886750d18058a584c77bcda9d95450d9255e96"
    sha256 cellar: :any_skip_relocation, ventura:        "58a6ea88d8cfdd7c1ef8fbfc5afb2e5e039bf932becb4c0293aeaefb636ceae3"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ca643695691ee1d49a4bb83be31dd5d5bc5ab10f8781b63b93a68020322c26"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6568c262100fd902f6a59d93aef335c1b77c7af8ef67de9d9896daa036a3dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2066d6d22c6b2c5020051e24622c4b7f852c2f8ce3fe9e7c4073a7e311b9e8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
