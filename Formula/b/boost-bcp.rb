class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.88.0/boost-1.88.0-b2-nodocs.tar.xz"
  sha256 "ad9ce2c91bc0977a7adc92d51558f3b9c53596bb88246a280175ebb475da1762"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8e002a55974a472bc3a578fbaa1fd915d7a13f0065444ebcf153b6fe479320a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ddbe2024ec99f3d5a53ff5f98cbc6773b5d3eb5421d8683739cdc6d95300a00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a42346d9849a8625053c04bf7b4443f004a542dddfea91ed794e1d6dcfbe4ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd736a775c362230f19fc186c9cfdd7d012829639e54fda96eb3e9445cbd809"
    sha256 cellar: :any_skip_relocation, ventura:       "50c827f9e992ff5dfb2fa2df38dd51601abe142ce4098afdcac4b736207c3856"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d48c4acb2a107f58c300c64142dc162837d40ef6862cb9b711db6b408c19c582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "333766f7346ac77c9d28122f7798ee112dc7ef6a34696259e7ca1117a493e92e"
  end

  depends_on "boost-build" => :build
  depends_on "boost" => :test

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--boost=#{Formula["boost"].opt_include}", "--scan", "./"
  end
end
