require "language/go"

class KinesisTail < Formula
  desc "tail(1) for Amazon Kinesis"
  homepage "https://github.com/kkung/kinesis-tail"
  url "https://github.com/kkung/kinesis-tail/archive/v0.1.tar.gz"
  sha256 "dcf5b9bd4bd759fff78218630b98cfa584df0ba798ff2dc98e9ce87ec975fb99"
  head "https://github.com/kkung/kinesis-tail.git"

  depends_on "go" => :build
  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "665c623d7f3e0ee276596b006655ba4dbe0565b0"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath do
      system "go", "build", "-o", "kinesis-tail"
      bin.install "kinesis-tail"
    end
  end

  test do
    assert_match(/MissingRegion/, shell_output("#{bin}/kinesns-tail").chomp)
  end
end
