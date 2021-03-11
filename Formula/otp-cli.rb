class OtpCli < Formula
  desc "Tool for generate otp code in terminal"
  homepage "https://github.com/chyroc/otp-cli"

  url "https://github.com/chyroc/otp-cli/releases/download/v0.3.0/otp-cli-0.3.0.tar.gz"
  sha256 "b0c3a0afb4f886db32bcc12ed3d6eec985fe9cf4487e4db412557dfbdd5dcafe"
  head "https://github.com/chyroc/otp-cli"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/chyroc/otp-cli"
    bin_path.install Dir["*"]
    cd bin_path do
      system "go", "build", *std_go_args
    end
  end

  test do
    assert_equal "otp-cli version v0.3.0\n", shell_output("#{bin}/otp-cli version")
  end
end
