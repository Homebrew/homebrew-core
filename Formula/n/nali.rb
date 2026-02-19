class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "8918e4c1c720dad1590a42fa04c5fea1ec862148127206e716daa16c1ce3561c"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15cbc69776a3b3868d0ec51b308fbeaece9d47ab8e70b782e4eae9bd545fc8df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15cbc69776a3b3868d0ec51b308fbeaece9d47ab8e70b782e4eae9bd545fc8df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15cbc69776a3b3868d0ec51b308fbeaece9d47ab8e70b782e4eae9bd545fc8df"
    sha256 cellar: :any_skip_relocation, sonoma:        "91eef6fba03ebf843e79d34efce36156c5516b472639951049405735b87e6bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421138218ebc31e11b1302c7d0dbf6e2ac4daab394c620606ada5531980cbbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93f1725e116d789e17cd905157e3f0466d41cd3ef105aba1b8f843a74a7a2bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"nali", shell_parameter_format: :cobra)
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
