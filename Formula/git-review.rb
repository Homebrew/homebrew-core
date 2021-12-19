class GitReview < Formula
  include Language::Python::Virtualenv

  desc "Submit git branches to gerrit for review"
  homepage "https://opendev.org/opendev/git-review"
  url "https://files.pythonhosted.org/packages/bb/0f/5eef0fc4a55d0ad2326330f183529ffb874685c9b3a69bd1093da09d2c65/git-review-2.2.0.tar.gz"
  sha256 "fd97a00e5c15173eb097cef8e8b7915df96d878ad11eb62cb44983642b8f3a63"
  license "Apache-2.0"
  head "https://opendev.org/opendev/git-review.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8a0b77015a08b8e6399d7e35e1c19f5e1dfa7581a1159bc571ca42ce2353ccd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8a0b77015a08b8e6399d7e35e1c19f5e1dfa7581a1159bc571ca42ce2353ccd"
    sha256 cellar: :any_skip_relocation, monterey:       "25bca3f3539864feb6578e417f23a6b94fd98a8e78b8c319875b8736481bdc3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bca3f3539864feb6578e417f23a6b94fd98a8e78b8c319875b8736481bdc3f"
    sha256 cellar: :any_skip_relocation, catalina:       "25bca3f3539864feb6578e417f23a6b94fd98a8e78b8c319875b8736481bdc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770e52b24f639c207b82b0a92434ca2e77fa1482878b2d1ae3ea95e549a0db8c"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
    man1.install gzip("git-review.1")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/brew.sh"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
