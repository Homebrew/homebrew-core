class Hyperkit < Formula
  desc "Toolkit for embedding hypervisor capabilities in your application"
  homepage "https://github.com/moby/hyperkit"
  url "https://github.com/moby/hyperkit.git", :tag => "v0.20180123"
  sha256 "382933118da3835056203d3d05923b554f36cc41a555a821516e11ccb7d16bf3"

  head do
    url "https://github.com/moby/hyperkit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "make"
    bin.install "build/hyperkit"
  end

  def caveats; <<~EOS
    To enable qcow support in the block backend an OCaml OPAM development
    environment is required with the qcow module available.

    A suitable environment can be setup by installing opam and libev via
    brew and using opam to install the appropriate libraries:

      $ brew install opam libev && \\
          opam init && eval `opam config env` && \\
          opam install uri qcow.0.10.3 conduit.1.0.0 lwt.3.1.0 \\
          qcow-tool mirage-block-unix.2.9.0 conf-libev logs fmt \\
          mirage-unix prometheus-app

    Read more https://github.com/moby/hyperkit#building
  EOS
  end

  test do
    pipe_output("#{bin}/hyperkit", "v")
  end
end
