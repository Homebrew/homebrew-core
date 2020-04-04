class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag      => "0.8.3",
      :revision => "b97e3593d564a1e069c0a022da8cbd98ca2c5a4b"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a325127c11c78285bfc7c68812dc6c0425c9c3305e32312c10c39e2dc2c1ce9" => :catalina
    sha256 "b785f70ac7b4cb766f7d09e6263268ed2d3934331c65b6f5fde4829a530d5fa3" => :mojave
    sha256 "e1807b5063dd15258a1fd041bdc21faea8f598e7c0c8a3f39557e880fc22ec2c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def build_elm_format_conf
    <<~EOS
      module Build_elm_format where

      gitDescribe :: String
      gitDescribe = "#{version}"
    EOS
  end

  def install
    defaults = buildpath/"generated/Build_elm_format.hs"
    defaults.write(build_elm_format_conf)

    (buildpath/"elm-format").install Dir["*"]

    cd "elm-format" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"
  end
end
