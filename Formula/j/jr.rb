class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/jrnd-io/jr/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ae8f8e8fecef16f2e95b69d25460ff4f4d28b112c9877eeaf37993addf18a46d"
  license "MIT"
  head "https://github.com/jrnd-io/jr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e8347db18863c01caa673f5b0e92cbf5b19074f6cdf231be2bd174a0390ed06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e21753c12cd216a40b151e9809df074adeb66b0b2a72c488a86406d1ae4be2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e94a9e1c57902aa030fa1f7f1994539fcd0708717c4b058f7ab1882f03ec70f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2252647355b1043206b7e16cfca108b678cedc0065090307823c6bb2a1e68ddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eadf3422a042e814b16b5f35e4f98213ed8d7ee2356eba584b693422edb2ec7"
    sha256 cellar: :any_skip_relocation, ventura:       "eb0c2a1c04d87eef167d2fb8717fbd2cdcb4112bd36cdae0c8462d234a813c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16cb5724b5db44f4cdc64875571ca63528412b92cf239117b9333fee77f826fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a947f3670797436fd4b1e4657433063fa943e04d276ffbae00b20107d72e06b1"
  end

  depends_on "go" => :build

  def install
    ENV.deparallelize { system "make", "all" }
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_SYSTEM_DIR: pkgetc
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
