class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.2.5.tar.gz"
  sha256 "993e0bb72e79c5168d78db5c14d84f69beeab819ab4d06f4d98fcddd23487207"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ddfe56cee0745cd76c267b9c581fd200a099bd29aaf83b2afcd03e03403784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ddfe56cee0745cd76c267b9c581fd200a099bd29aaf83b2afcd03e03403784"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62ddfe56cee0745cd76c267b9c581fd200a099bd29aaf83b2afcd03e03403784"
    sha256 cellar: :any_skip_relocation, sonoma:        "57c16bdfa9b126ce3295df6d548969c7cecbadbc7e8c43e8b87d8f5f25629812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138ccd6f663df63ebfdd6322065cc8e38174d4537679d86908d3956aa646171c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin/"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin/"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}/croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end
