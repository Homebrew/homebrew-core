class Functions < Formula
  desc "The serverless microservices platform."
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.25.tar.gz"
  sha256 "9c26678e7a7c9606a5c8fc32288624dccb2efbb493ed8747550b8f4faa7d449a"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/iron-io/functions"
    dir.install Dir["*"]
    cd dir do
      system "make"
      system "go", "build", "-o", bin/"fn-server"
      cd "fn"
      system "glide", "install", "-v"
      system "go", "build", "-o", bin/"fn"
    end
  end

  test do
    system bin/"fn-server", "-help"
  end
end
