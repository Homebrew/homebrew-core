class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "aac9e31da12abdf5065b19738058738712efbf379f69056dbda1a6bd0c124c0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df126d1091922f2f25086b0ed7f4524bcb539b7915d3e2327f4383bc7b671e48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046ff07e26bf346e9edae7802a4b2ba340a75ef91d7ae31d4b7277b8d61facee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77b29b54abe9c4b289e308a81482766e1c75a92f963522387e48bb83c8d4f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7228f946d6b7d74badf7cb706f1ca8a8b875d21953ec7f6a0eb2ec4b9477a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a07d1c7caaf46024041b806477d93f25a380e07d7ba88d3720e968ae824ee7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21df3b909376d5cf985debfe951c5939f6d54dd38b0ef7ecd9f50c2726b5236"
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

    Open3.popen3({ "NO_COLOR" => "true" }, bin/"docuum") do |_, _, stderr, wait_thread|
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
