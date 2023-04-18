class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.17.2.tar.gz"
  sha256 "eaf08b8cdac14504307ae31920d3d094101d901cd390436ca401b3ba1e7a8924"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f3bd1a826c8676e1e3ba93df02b84461ce15166f7fa40ae6e90fc02503c003"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9f3bd1a826c8676e1e3ba93df02b84461ce15166f7fa40ae6e90fc02503c003"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9f3bd1a826c8676e1e3ba93df02b84461ce15166f7fa40ae6e90fc02503c003"
    sha256 cellar: :any_skip_relocation, ventura:        "3f6220f6a107d286b8a52dec29abc2dab476a374ce7b9e34d33f70d7026ac551"
    sha256 cellar: :any_skip_relocation, monterey:       "3f6220f6a107d286b8a52dec29abc2dab476a374ce7b9e34d33f70d7026ac551"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f6220f6a107d286b8a52dec29abc2dab476a374ce7b9e34d33f70d7026ac551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b394040a7237dd7520418f51d397d63eb201954538c925f1a471bafb123d33b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
