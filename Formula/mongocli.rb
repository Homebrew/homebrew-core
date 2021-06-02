class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongocli"
  url "https://github.com/mongodb/mongocli/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "184f0a13ca0cfb642203727b4971622a761c77ac85066fc51689356690f5e2d0"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "0f7699e45eca5e715b33822a8755d3b3b1469aaa",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    (bash_completion/"mongocli").write `#{bin}/mongocli completion bash`
    (fish_completion/"mongocli.fish").write `#{bin}/mongocli completion fish`
    (zsh_completion/"_mongocli").write `#{bin}/mongocli completion zsh`
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
  end
end
