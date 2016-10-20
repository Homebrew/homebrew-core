class Fly < Formula
  desc "Command line interface to Concourse"
  homepage "https://concourse.ci"
  url "https://github.com/concourse/concourse.git",
    :tag => "v2.3.1",
    :revision => "0fc7e2f6d46412ea70c8a9d81671c66d27276e44"

  bottle :unneeded
  
  depends_on "go"

  def install
    cd "src/github.com/concourse/fly" do
      ENV["GOPATH"] = buildpath
      system "go", "build", "-o", "fly"
      bin.install "fly"
    end
  end

  test do
    system "#{bin}/fly", "help"
  end
end
