class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.5.0.tar.gz"
  sha256 "66f2a876eba15d71cfd08b56667fb07e1d49d383aa17d31696a39e794e23ba92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54012038ed3634d1ad94db5f90621ac50d0d30533a88850ddb651a8f6399ac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04c5124e2c3780ad5519ded1c6a469563c0b45d8b020dbd14d7ca1bea4dc9cad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ccdcf167ae756191b74445065bade50ac36489c7427d67ee7a5331760de34da"
    sha256 cellar: :any_skip_relocation, ventura:        "0bfda1b6f367cd6f5f2dd5d109f3326bd42f20275435166e003779f69366466a"
    sha256 cellar: :any_skip_relocation, monterey:       "567a9f5ad2f29621ca3bb54579f429d47c4bc1b208d5e53a2069b8026ff84ecb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce0134788a482449b01b09604d19675471f014f94b727f5fa961f5ee91530e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc968cb56ef6328c33319040d72bc8af1817a9d01240797ab4e9c155a7b2984"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
  end

  test do
    test_file = testpath/"test.md"
    test_file.write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS

    # failed with Linux CI run, but works with local run
    # https://github.com/charmbracelet/glow/issues/454
    if OS.linux?
      system bin/"glow", test_file
    else
      assert_match "# header", shell_output("#{bin}/glow #{test_file}")
    end
  end
end
