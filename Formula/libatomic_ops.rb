class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz"
  sha256 "587edf60817f56daf1e1ab38a4b3c729b8e846ff67b4f62a6157183708f099af"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c9ba6b9de11add3a64743a7a29e55e9a08eec18df5258e3881126ba0157f32c3"
    sha256 cellar: :any_skip_relocation, big_sur:       "cafd6f8c5d49f8d80e5c02a43fd3183c1abf3f26315c6c21344598df41e6134c"
    sha256 cellar: :any_skip_relocation, catalina:      "d102cc71b5959eac9f8ecbc5029801ea2a544ad5b6602c586e5d5d33c67ebd55"
    sha256 cellar: :any_skip_relocation, mojave:        "b509d8669c5336775b0462c3e1464419d083bccc0bf43f8dab8fa3eb0ac44405"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2e3053c22101fd8baf693ca404f258763b15e77372b5293e999f8bbc8b032522"
    sha256 cellar: :any_skip_relocation, sierra:        "d94aa0351ce2de312d0b31a64d48059473a170d9704968378cf121ad097d7d9b"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
