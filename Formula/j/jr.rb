class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/jrnd-io/jr/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ae8f8e8fecef16f2e95b69d25460ff4f4d28b112c9877eeaf37993addf18a46d"
  license "MIT"
  head "https://github.com/jrnd-io/jr.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "399634610161df53cbbeceed8121518a1e3ed856aed4058b4d9877563f639fb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3287aeddbe1d654e4de4c907ab86aeb2f667e026e4a6e42ff20b432d0a9623b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b29e79883c761f778628b0328472d208bd8bb1e99ed336fa987ac6da08174f12"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7ea019fcb7b112f592b88beba76fe7af0a1d35a5858e93bd78a695bef0003c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a420499d2089911bdba702881348ff01703ca4f0069b771f8304e071cbe9de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18666a02f967744d1b8e9e83d626c3f463c88c3a2ec95eb7cfc7ea8df03b45fc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ENV.deparallelize { system "make", "all" }
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_SYSTEM_DIR: pkgetc

    generate_completions_from_executable(libexec/"jr", shell_parameter_format: :cobra)
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
