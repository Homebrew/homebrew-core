class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/refs/tags/0.19.2.tar.gz"
  sha256 "745b1edfea2f8e3b36cf6f77ae3b59fd86e8e397d427971f6d903f9fce6163a5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "70f6f7f915c20c7b494a0c68ea5d4eafb7a6cfef22b02e229cd084d0bffe4bf3"
    sha256 cellar: :any, arm64_sequoia: "9300c6c9314285996acbde5b1cf6dc9d8d24478aff12506b7a949dc8b35da2ea"
    sha256 cellar: :any, arm64_sonoma:  "062b153f12bcefbac51e9768680fa72e71ed30d6e7967e9030623e1bf1ab29d7"
    sha256 cellar: :any, sonoma:        "f099f4b3604eb1d29cf81f49c70aa66f9c5a1da262c9196ae7a5b2656c8e217e"
    sha256 cellar: :any, arm64_linux:   "6761d2c3c643a821b2e7274475b0086ef590a495ad1436c070648e5faab58e26"
    sha256 cellar: :any, x86_64_linux:  "52fc6c86c6e28b1b75275e0b613e06c388426dbb3ae3cc9a91ff648ab896775c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --jobs=#{ENV.make_jobs}
    ]

    # Following the process from the Dockerfile for building elm binaries here:
    #  https://github.com/elm/compiler/blob/main/installers/linux/Dockerfile
    # This process does not use `cabal install`
    system "cabal", "update"
    system "cabal", "build", "elm", *args
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
