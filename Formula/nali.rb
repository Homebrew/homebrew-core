class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.5.3.tar.gz"
  sha256 "e47c330bd66f6969b625571843451913f5667a25b2852e254ab028b3f3ed575b"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14f512b35424185762a13b4530c21670019f13cec57d010c627c779115f4d4dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b75b5a25571a4bad4cb7222ecdf7414cb656ecb1f8a147bc6c69e38fb40ee80"
    sha256 cellar: :any_skip_relocation, monterey:       "5727378720de8ee209ddb413d9431c1eae775f7ea6abf7588fb9341b7d665269"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5b5912bbad0cd1f51dc017ced4905e422b8408846424fe9bf1dbf4b5c34be2e"
    sha256 cellar: :any_skip_relocation, catalina:       "0f35d78a2eeac2ff6c2cf27644ce093ba0ad2777251174525f6a31c01b2e4f9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "669b5c4bbfebbc8570ff49c5b6b611cb1d426d2ff9d80bcaa70846588f83d9e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"nali", "completion")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
