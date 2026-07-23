class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/refs/tags/v5.9.2.tar.gz"
  sha256 "5cf5f77767568c25cf880acc2d0a32ee3d399e935475ab1626e8192fc3b07390"
  license "LGPL-2.1-or-later"
  head "https://github.com/polyml/polyml.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2e1a65ca5584fbed5d8809d26b612abdedd723df506daa33d82bdd2144a8c8f7"
    sha256 arm64_sequoia: "73159083107e398682b609d20c700a909a15e9cf8ccb95fc6311c567cc39a9a1"
    sha256 arm64_sonoma:  "e2f1500bcbb66c6ac5ff92627229efba5c6c3702f22d17bfd7a5648801a22125"
    sha256 sonoma:        "ebfa52db23d6ce50906a8c66957230db9ba791429c5e1e5cbc96bd2ad3eed16c"
    sha256 arm64_linux:   "dbb61f66617d3c19fc0d8cc1d5eadd8c2986fa048af9e1e720540ae3e8aae40a"
    sha256 x86_64_linux:  "cce638901b7e6baf678c145347a882cbc4589d92e52b61e0dc45ea5b30199592"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}/poly --script hello.ml")
  end
end
