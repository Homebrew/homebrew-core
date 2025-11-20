class Arelo < Formula
  desc "Simple auto reload (live reload) utility"
  homepage "https://github.com/makiuchi-d/arelo"
  url "https://github.com/makiuchi-d/arelo/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "f687e04187145aa6ccaf68fc995f9e8297387a2f27871ccb132625e0635cf15d"
  license "MIT"
  head "https://github.com/makiuchi-d/arelo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef8b5e963b9357f36274cc3215e3c4bef786c2ca7f81d844ed7161426725d9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef8b5e963b9357f36274cc3215e3c4bef786c2ca7f81d844ed7161426725d9a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef8b5e963b9357f36274cc3215e3c4bef786c2ca7f81d844ed7161426725d9a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "14da6734979c2342999a2387f2682858ca121f8252dbb946911b9bd64a2e33df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8051a15270ccfa1ac4ba18bb6421ecf51e1f6d3a89a462809890a6b41c760ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "592beafb82bd1f10d9b8a303b0d224e0378d71eac089a47be9f141c266788e35"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arelo --version")

    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo "Hello, world!"
    EOS
    chmod 0755, testpath/"test.sh"

    logfile = testpath/"arelo.log"
    arelo_pid = spawn bin/"arelo", "--pattern", "test.sh", "--", "./test.sh", out: logfile.to_s

    sleep 1
    touch testpath/"test.sh"
    sleep 1

    assert_path_exists testpath/"test.sh"
    assert_match "Hello, world!", logfile.read
  ensure
    Process.kill("TERM", arelo_pid)
    Process.wait(arelo_pid)
  end
end
