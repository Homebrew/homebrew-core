class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r5.tar.gz"
  sha256 "ade6c4cc750235a51d4fd6aeeabe8fa7adfcea90504804e739d492bd01e534bb"

  depends_on "dep" => :build
  depends_on "go" => :build

  patch do
    url "https://github.com/gokcehan/lf/commit/a607e53e5110b3ed3fd28bdc8e8c87a48f2e5b85.patch?full_index=1"
    sha256 "3c46f94a5ebc67028bb7b9ad3bd93ea20bd012d5b784f88b30d418a930279afb"
  end

  patch do
    url "https://github.com/gokcehan/lf/commit/fe786aae4cc46981b60f58f37cde0c4911bd6030.patch?full_index=1"
    sha256 "767ff655754792381c9c50ac557a5c9bb620fc0e0c73c9f76f66bd9b7045496b"
  end

  patch do
    url "https://github.com/gokcehan/lf/commit/4c54acebebc6cf2619bd006d73ae2e0a90d284fd.patch?full_index=1"
    sha256 "e73252c8f4396369d57dd14dfe50abf1ab4643d2b4048424e198286c30b9da99"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "dep", "ensure", "-vendor-only"
      chmod 0755, "gen/build.sh" # remove for lf > 5
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"lf", "-doc"
  end
end
