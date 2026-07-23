class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/refs/tags/0.19.2.tar.gz"
  sha256 "745b1edfea2f8e3b36cf6f77ae3b59fd86e8e397d427971f6d903f9fce6163a5"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "bc5a95d3d5f3a03667fa07c79eb064a657b42953eb737a98014932ecef3230a8"
    sha256 cellar: :any, arm64_sequoia: "2a8c28d024de7baeb84a85ca1039317f0973c04270ee4368fa38e5c181a17029"
    sha256 cellar: :any, arm64_sonoma:  "8c368c94379d704f5c3cb0de16ff3e55623b3b2538bde8da581bb228f32b2d5c"
    sha256 cellar: :any, sonoma:        "e6533b03db2f6918fb74b40948c2172206f491ba29450cf320f671ac379aeade"
    sha256 cellar: :any, arm64_linux:   "35ec2376f0ec9a4aa933d58c6a10ee6efb36f2aebe733c09889ba2dc622ef514"
    sha256 cellar: :any, x86_64_linux:  "f4cb28e29d93cbaa9aa31895bf3ca71dba4a93259425693bd7da91d0f24fcd90"
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
    # Following the process from the Dockerfile for building elm binaries here:
    #  https://github.com/elm/compiler/blob/main/installers/linux/Dockerfile
    # This process does not use `cabal install`
    system "cabal", "update"
    system "cabal", "v2-build", "elm", *std_cabal_v2_args.reject { it["install"] }
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
