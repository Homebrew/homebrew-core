class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize.git",
      :tag      => "v0.6.1",
      :revision => "7c5cd7c34dcf1c81f6b4db132ebceabdaae17153"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jwilder/dockerize").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"
    cd "src/github.com/jwilder/dockerize" do
      system "make", "dist"
      bin.install "dist/darwin/amd64/dockerize"
    end
  end

  test do
    system "#{bin}/dockerize", "-wait", "http://www.google.com", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
