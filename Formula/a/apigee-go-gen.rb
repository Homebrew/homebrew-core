class ApigeeGoGen < Formula
  desc "Tool to generate Apigee proxies, flows, etc. in Go"
  homepage "https://apigee.github.io/apigee-go-gen/"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/apigee/apigee-go-gen/releases/download/v1.1.0-beta.2/apigee-go-gen_Darwin_arm64.tar.gz"
      sha256 "0b6d6dd69340109336a81dae1784ea5f4ac6fc731ed08bf3628b1d0c3264b328"
    else
      url "https://github.com/apigee/apigee-go-gen/releases/download/v1.1.0-beta.2/apigee-go-gen_Darwin_x86_64.tar.gz"
      sha256 "c385138135abadf9807a396b3bd5d9a36d4e2a47dd5a9dcbad68d02a8a7a27e8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      odie "ApigeeGoGen binary not available for Linux ARM64 yet"
    else
      url "https://github.com/apigee/apigee-go-gen/releases/download/v1.1.0-beta.2/apigee-go-gen_Linux_x86_64.tar.gz"
      sha256 "86d06b54b8c2d516cce29decb1c3f68f5615a7e7b47ad49587807fdad0f018e6"
    end
  end

  head "https://github.com/apigee/apigee-go-gen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build, :head

  def install
    if build.head?
      system "go", "build", *std_go_args, "./cmd/apigee-go-gen"
    else
      bin.install "apigee-go-gen"
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/apigee-go-gen --help")
    output = shell_output("#{bin}/apigee-go-gen list 2>&1", 1) rescue ""
    assert_match(/No proxies found|Usage/, output)
  end
end
