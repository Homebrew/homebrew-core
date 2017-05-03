class Gopass < Formula
  desc "The slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.justwatch.com/gopass"
  url "https://www.justwatch.com/gopass/releases/1.0.2/gopass-1.0.2.tar.gz"
  sha256 "a2c64329355f72527a1e269b3ad97cd2d37012ebf283210ef947c10657d8f650"
  head "https://github.com/justwatchcom/gopass.git"

  depends_on "go" => :build

  depends_on :gpg => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justwatchcom/gopass").install buildpath.children

    cd "src/github.com/justwatchcom/gopass" do
      ENV["PREFIX"] = prefix
      system "make", "install"
    end

    (bash_completion/"gopass-completion.bash").write `#{bin}/gopass completion bash`
  end

  test do
    # TODO: make this work, is currently stuck
    #
    # Gpg.create_test_key(testpath)
    # system bin/"gopass", "init", "Testing"
    # system bin/"gopass", "generate", "Email/testing@foo.bar", "15"
    # assert File.exist?(".password-store/Email/testing@foo.bar.gpg")

    assert_match version.to_s, shell_output("#{bin}/gopass version")
  end
end
