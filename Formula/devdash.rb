class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.3.0.tar.gz"
  sha256 "a3198c9c5ae8b45f000fd24b60d4e26f7bd0fe24f8f484259832f70725ff35fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc3e56b0b9cefdb3e2871cd27ca5499d61ec1e2d182a9390e3303d2d6aee3a62" => :catalina
    sha256 "565f301ac09f5f55cade8db7d70bf559a8e1c422b7c88b2859e418e08e760914" => :mojave
    sha256 "72e269d84c8a1e0d973fcf892a343a1f3b11db63b69788581997cb62e91588f8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/devdash", "./cmd/devdash"
  end

  test do
    system bin/"devdash", "-term"
  end
end
