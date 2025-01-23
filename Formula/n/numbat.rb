class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "abf7a79db4c8eb0e6ddd7a67efafcaf7b9d8c109ad255c21207be2bb54a12ba2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b312c92bfaae42c0588bdeb1e7bf1027c66979ac3f1ca21ad024e595131e8b55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cee7eada9f5dfd8b704e3d4b93513cc97e572212a046cc0c01767409d1d3760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95c395ce4cefde5442db291e091228809b57b9827ef83448225f0d7412a3701a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d7ab58dedbaea17439e40cf6400bbb4b46b8fbcb7b4531269c183a59866bf7a"
    sha256 cellar: :any_skip_relocation, ventura:       "702e665e7c0b05eeb049ce0a8e7008743e101a05365ed13a70bc63439c39abc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8607f57131f2c2efff1aaaa2b3c8d8b3d225689b5dd67b8ac2ff1c80394a67"
  end

  depends_on "rust" => :build

  def install
    ENV["NUMBAT_SYSTEM_MODULE_PATH"] = "#{pkgshare}/modules"
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")

    pkgshare.install "numbat/modules"
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
