class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/refs/tags/0.19.1.tar.gz"
  sha256 "aa161caca775cef1bbb04bcdeb4471d3aabcf87b6d9d9d5b0d62d3052e8250b1"
  license "BSD-3-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "ec3ce79abe4bb3959d399450deb363f9b5923d9095f4004c242fc9cc82360fbc"
    sha256 cellar: :any,                 arm64_sequoia: "f58530d4c64929c2966bab949d9ffdbebf8dfebf5e3226146715412f43490a4e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1e07dfaa0dd66ac5336102fd1dba224508993c8e84a7cb9699bc77a1106060b"
    sha256 cellar: :any,                 sonoma:        "6c99fb8f3afbeaf136cda6f45534add032113307ec48aa15ca918b192b46eba4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc5513922a45366dc5f46202bed2e6870cc319a9b666f49b31485b08efdfb26c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aedc01216943882eec74e6a2e303e1ecae098cd7270deebe10b4748eecea59b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  patch do
    # elm's tarball is not a proper cabal tarball, it contains multiple cabal files.
    # Add `cabal.project` lets cabal-install treat this tarball as cabal project correctly.
    # https://github.com/elm/compiler/pull/2159
    url "https://github.com/elm/compiler/commit/eb566e901a419a6620e43c18faf89f57f0827124.patch?full_index=1"
    sha256 "556ff15fb4d8e5ca6e853280e35389c8875fa31a543204b315b55ec2ac967624"
  end

  patch do
    # These patches allow elm to build on ghc 9.4+.
    url "https://github.com/elm/compiler/commit/0421dfbe48e53d880a401e201890eac0b3de5f06.patch?full_index=1"
    sha256 "b498e39112ab7306b18b47821e799bf436d0c2151836187388c2a6b6f32bd437"
  end

  def install
    # Workaround to build with GHC 9.14. Related issues:
    # https://github.com/well-typed/cborg/issues/373
    # https://github.com/haskellari/these/issues/211
    args = %w[
      --allow-newer=cborg:base,cborg:containers,serialise:base,serialise:containers
      --allow-newer=these:base
      --allow-newer=snap-server:containers
      --constraint=tls>=2
    ]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~JSON
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
    JSON

    src_path = testpath/"Hello.elm"
    src_path.write <<~ELM
      module Hello exposing (main)
      import Html exposing (text)
      main = text "Hello, world!"
    ELM

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_path_exists out_path
  end
end
