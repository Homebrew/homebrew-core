class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "fe52c1b067a793830ad8a7b00417f60736b06a42aae85994ff8f9a5dd1b295d2"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6d71f2cc9755d47c10de9a083fa09c2cc3c1d353fd4060541d45df0b9d72a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6066bbc7060df26fd630ced1ae76e1f310f2f4c2c117fccbdf60e07e7aa2cb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c34df133dea6abbe2d97db033060ead2e8c876e080590e24d8e53f427768c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f14852c9fd57d4556fcb9fb5beb4e5f6efcb23e8325f164586e86768eb50891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd6ecc5d10cc68ea486d72aca8a32bb5e1c29b649a7bf7cb43ea031ba14d29e"
    sha256 cellar: :any,                 x86_64_linux:  "c6ae9b8bb9a2f5946a920e7594a1f040fe580f13fccddba3af12447dddc31ff4"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
