class Alice < Formula
  desc "Radical OCaml build system"
  homepage "https://github.com/alicecaml/alice"
  url "https://github.com/alicecaml/alice/releases/download/0.1.1/alice-0.1.1-hermetic-source.tar.gz"
  sha256 "eb8705de406441675747a639351d0d59bffe7b9f5b05ec9b6e11b4c4c9d7a6ee"
  license "MIT"

  depends_on "dune" => :build
  depends_on "ocaml" => :test

  def install
    ENV["DUNE_CONFIG__PKG_BUILD_PROGRESS"] = "enabled"
    system "dune", "build", "@install", "--release", "--only-packages", "alice"
    system "dune", "install", "--prefix=#{prefix}", "alice"
  end

  test do
    # Make a new executable package and run it.
    system bin/"alice", "new", "--exe", "hello"
    system bin/"alice", "run", "--manifest-path", "hello/Alice.toml"
  end
end
