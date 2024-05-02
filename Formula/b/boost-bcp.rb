class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-b2-nodocs.tar.xz"
  sha256 "09f0628bded81d20b0145b30925d7d7492fd99583671586525d5d66d4c28266a"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbfee5ecd3058d8aa03455862ec25ce443b0758615b6eacde25bad9a1d876030"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4abc249700ed24319885622e84d80b0247cddff21a1f52e3f471bfb0235b2222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bd1f0c66ed1a9b1ffda0053c7e63f5cdf1398f5cdfbc49de4a29f76c439334"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe3c870ae07dfa88f204a8304b409d6e542781e5fbe3c0c3e120b578bd394176"
    sha256 cellar: :any_skip_relocation, ventura:        "68957f99465e4cd0914ab01e4bcc975d33151c5012ddda3b45d807e91475a056"
    sha256 cellar: :any_skip_relocation, monterey:       "b733a211ca99cf02048ef17311dde9b77d99446940825f8f3d612848ffb25a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c04ca444426fa4600e87d71c158fe0561d478e73bd263fde39daea3117c85fc"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  # Fix build with latest boost::filesystem by applying commit from open PR
  # PR ref: https://github.com/boostorg/bcp/pull/18
  patch do
    url "https://github.com/boostorg/bcp/commit/cd21e9b4a749a77c24facf2da44f01e032c40842.patch?full_index=1"
    sha256 "09fdccb8ebdef5d13bbccbeb48eec7d14bb6916c75ea5c14fc439ff2bbd0f080"
    directory "tools/bcp"
  end
  patch do
    url "https://github.com/boostorg/bcp/commit/c98516b5b76e9132eba78a399af9c95ec8d23bd4.patch?full_index=1"
    sha256 "557221988cda08f5183310c5ef50fdef79e4c096c8e849cd42f170c802ba7b6a"
    directory "tools/bcp"
  end

  def install
    # remove internal reference to use brewed boost-build
    rm "boost-build.jam"
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
