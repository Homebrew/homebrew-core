class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "23ffc5418e133b0012d805c6ab93442046527bdef6b3eff96609db89e0738875"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92da28061caa8936eb9d242428228c97c7f712bbdf1abb19565fde0e986bfd6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81295a263139fc40b9791f101fb2517a8e722064f2045bbfecfa7897d7311387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffde25408cd305d7db6f7734f52929a067e0892ef8cdacc17f179c6c9955ca23"
    sha256 cellar: :any_skip_relocation, ventura:        "dcfddb3b433139fe9dbd8f5d7961cf689dbece7fb99ff2e85b3698012ab583ef"
    sha256 cellar: :any_skip_relocation, monterey:       "e51317791fd1ffd91982426048f21de3d833df93e649c9b128d054c06b7b91c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6965806410d4a9cab1fd2bf35de0d5e8de6256676ad7b34e87073beecb82f334"
    sha256 cellar: :any_skip_relocation, catalina:       "34dcf644b5a042c86febc6cf259bb98ba35a9e90a4c40532f780f33438d637a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a50198993283a76c683a178a300a44866c323aec4cca69f15dce201c36b6ce8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gobuster", "completion")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/gobuster dir -u https://buffered.io -w words.txt 2>&1")
    assert_match "Finished", output

    assert_match version.major_minor.to_s, shell_output(bin/"gobuster version")
  end
end
