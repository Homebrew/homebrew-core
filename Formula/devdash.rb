class Devdash < Formula
  desc "Highly Configurable Terminal Dashboard for Developers"
  homepage "https://thedevdash.com"
  url "https://github.com/Phantas0s/devdash/archive/v0.2.0.tar.gz"
  sha256 "11760bb308680bcbfb138dd57df4a6b4b069ce082cf9e53275028bd23ea23b78"

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
