class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.7.tar.gz"
  sha256 "8c3bd6c558ab6cb043699498bb008c2113d73a6ecd312d0af68d64eb59806ebe"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf5c915106cceeccb20c6df9da20698e38abe86d4bb9522907c22b6f66679f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7fdab936f47e1fd33a1a93f957800a97c01679a3aa4736dc890e82257f16a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7045c8ea5944451460005548f0ac6005e92fc4a8d33046eb2e457adf10710cc2"
    sha256 cellar: :any_skip_relocation, ventura:        "c3760ec31f2f355dbb17dcd938fbd9afcfe210bc96827ce53bc1de19b0e498cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e2906dcf96506c9756a9cbfdef2c594ab5b99f7753c7cbc703c95beb20621055"
    sha256 cellar: :any_skip_relocation, big_sur:        "fde65258f6677820a72be90142517a77832936c4ce584de821b3dad796493c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587f7d5b6e79e442fda0cb44eca82ad4e62be13f43f2a50176fdec9bd3a63838"
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end
