class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/refs/tags/0.19.3.tar.gz"
  sha256 "e051f8700578a0920024ba9eb3496df6336119058ef996579b1b4a574b8313fa"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "58aab6f16a5900cad12eb45300f7d80ca00cbf4ab993cda6b4a7ec0ef98963ad"
    sha256 cellar: :any, arm64_tahoe:       "d7269573de9e73adb8940893d7009eca38c008236e8738119ab02e9f5c77d057"
    sha256 cellar: :any, arm64_sequoia:     "71ef1668e5f6c738e40bbd154cf72e94f0c4e2616b295c5694b2319e943235ee"
    sha256 cellar: :any, arm64_linux:       "6baa8a969d9e526575606ff040499e3e13be19c11e8dc5914f4a9af6920aaf3d"
    sha256 cellar: :any, x86_64_linux:      "4fb7148cfee2d86353a61e0e78b9534ce79c8d84154d3cf4f8365cf0182aca5b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # The reactor frontend is compiled by Template Haskell, which downloads Elm packages,
  # so this cannot use an offline `fetch` phase; `elm make` in the test downloads them too.
  allow_network_access! [:build, :test]

  def install
    # Following the process from the Dockerfile for building elm binaries here:
    #  https://github.com/elm/compiler/blob/main/installers/linux/Dockerfile
    # This process does not use `cabal install`
    system "cabal", "update"
    system "cabal", "v2-build", "elm", *std_cabal_v2_args(installdir: false)
    bin.install Utils.safe_popen_read("cabal", "list-bin", "elm").chomp
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
        "elm-version": "#{version}",
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
