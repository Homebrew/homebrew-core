class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize.git",
      :tag      => "v0.6.1",
      :revision => "7c5cd7c34dcf1c81f6b4db132ebceabdaae17153"

  bottle do
    cellar :any_skip_relocation
    sha256 "69bccb9e77c9c13b9ae8003f5f11ca4181bd16b5b287cbd9df14a5cb7d963b8c" => :catalina
    sha256 "94d889365e9e7c502449a79a431e4731faec239a1d2b18f65bf204671890f285" => :mojave
    sha256 "3a88ca84f7279093a08fda378d2e502de8f3e255a9cd36480473b4c22972854e" => :high_sierra
    sha256 "94083315a1f3b4e812d0468603900c691ab28d8c16762574c87a922863628b29" => :sierra
  end

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
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
