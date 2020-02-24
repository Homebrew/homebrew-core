class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.3.0.tar.gz"
  sha256 "a3198c9c5ae8b45f000fd24b60d4e26f7bd0fe24f8f484259832f70725ff35fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "61dad3989ec4abe1974a3c4f3b07df45c2b1595a5130cde2fcf318b30f3c5183" => :catalina
    sha256 "5ac83d288c59595929f60649342a0f858063c34588b50a7419b55b85fe3173e9" => :mojave
    sha256 "b4111ca6ffa4de540c174abbbd902d533a63c628d1bdd050f9b5afc3e5aeb19c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/devdash", "./cmd/devdash"
  end

  test do
    system bin/"devdash", "-term"
  end
end
