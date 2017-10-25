class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber.git",
    :tag => "v1.9.0",
    :revision => "acc4072df92f2763217ccfa5373e14f342e178ba"
  sha256 "098568ddda04956b8dc270aa8e6b4eb83d8cfe92add8ea0172715eab7db050cb"
  head "https://github.com/segmentio/chamber.git"

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/segmentio/chamber"
    path.install Dir["{*,.git}"]

    cd buildpath/"src/github.com/segmentio/chamber" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"chamber"
    end
  end

  test do
    system bin/"chamber", "-h"
  end
end
