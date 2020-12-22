class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/0.19.1.tar.gz"
  sha256 "aa161caca775cef1bbb04bcdeb4471d3aabcf87b6d9d9d5b0d62d3052e8250b1"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1bbfe4ff7deba3ed60eb55b81b86b6d3346325bea584802ca1212369f0fa0bb" => :catalina
    sha256 "288eeb47caccfaa9bae220492cee8de7206d40b7760e1e309a139a2398f9710d" => :mojave
    sha256 "7fb65ff925701c39bbc7d9a5099cd88f10a56949ae019bc8817035ed1d56edbd" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  patch do
    # elm's tarball is not a proper cabal tarball, it contains multiple cabal files.
    # Add `cabal.project` lets cabal-install treat this tarball as cabal project correctly.
    # https://github.com/elm/compiler/pull/2159
    url "https://github.com/elm/compiler/commit/eb566e901a419a6620e43c18faf89f57f0827124.patch?full_index=1"
    sha256 "556ff15fb4d8e5ca6e853280e35389c8875fa31a543204b315b55ec2ac967624"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~EOS
      {
        "type": "application",
        "source-directories": [
                  "."
        ],
        "elm-version": "0.19.1",
        "dependencies": {
                "direct": {
                    "elm/browser": "1.0.0",
                    "elm/core": "1.0.0",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.0.0",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.0"
                }
        },
        "test-dependencies": {
          "direct": {},
            "indirect": {}
        }
      }
    EOS

    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      module Hello exposing (main)
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
