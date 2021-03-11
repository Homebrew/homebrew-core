class OtpCli < Formula
  desc "Tool for generate otp code in terminal"
  homepage "https://github.com/chyroc/otp-cli"

  url "https://github.com/chyroc/otp-cli/releases/download/v0.2.0/otp-cli-0.2.0.tar.gz"
  sha256 "7e223d86e924e95e722b6c2b69acd0a4963085df2726132fcc6c0731caa93150"
  head "https://github.com/chyroc/otp-cli"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/chyroc/otp-cli"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", "-o", bin/"otp-cli", "."
    end
  end

  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "otp-cli", shell_output("#{bin}/otp-cli -h 2>&1", 2)
  end
end
