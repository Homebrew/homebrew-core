class Extism < Formula
  desc "Extend anything with WebAssembly"
  homepage "https://extism.org"
  VERSION = "v0.0.1-rc.4".freeze
  url "https://github.com/extism/extism/archive/refs/tags/#{VERSION}.tar.gz"
  sha256 "8c60d879d2d92bdadd174889c41a22983f4456d2baf3eb2b67451e71aa5f1ac1"
  license "BSD-3-Clause"

  depends_on "rust" => :build

  resource "cli" do
    url "https://raw.githubusercontent.com/extism/cli/main/extism_cli/__init__.py"
    # TODO: enable sha once we have releases of the cli
    # sha256 "dde4308c9df551d77e6ff9f3ae116777433a5870bedb6be4a96567970154a79a"
  end

  def install
    # it seems i need this make build before make install
    # otherwise i was getting compile errors on serde
    system "make", "build"
    with_env DEST: prefix do
      system "make", "install"
    end
    resource("cli").stage do
      mkdir_p bin.to_s
      bin.install "__init__.py" => "extism"
    end
  end

  test do
    system "extism", "info"
  end
end
