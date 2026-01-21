class Cmdshelf < Formula
  desc "Better scripting life with cmdshelf"
  homepage "https://github.com/toshi0383/cmdshelf"
  url "https://github.com/toshi0383/cmdshelf/archive/refs/tags/2.0.2.tar.gz"
  sha256 "dea2ea567cfa67196664629ceda5bc775040b472c25e96944c19c74892d69539"
  license any_of: ["Apache-2.0", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1861366a11845c9df0ea980488fa0717b74897c9a4e15db3fe69b1b6060c5022"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9774fb5ac602f84fb7b56c0409d688e0d70d810a36336a4ecdfb3a61cf5e40c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c510678189b00d66e3fe93ceae94f0475d8904e9d5c47f5dfcf99ba7b766a07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5e08b8759ea2720bb5409922772fd9432a3c9db493db0567b2f45139aa589b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4658ed5c59252828c4d8137ccc105228477dcb18512284899fce0ea2359791b6"
    sha256 cellar: :any_skip_relocation, ventura:       "10633921cd251385fd77106fb77d8fded40f0ffab37e9137d8d5004ea6867d1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "987be95a898af28fd47ade9f5279020f1bf1674ed3b279b7f32b21cda9b1ac6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54c84920fa8bd1abe7126270c1f1046a5a8d4932baad7b14982a9dbb4ec2189"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man.install Dir["docs/man/*"]
    bash_completion.install "cmdshelf-completion.bash" => "cmdshelf"
  end

  test do
    system bin/"cmdshelf", "remote", "add", "test", "git@github.com:toshi0383/scripts.git"
    list_output = shell_output("#{bin}/cmdshelf remote list").chomp
    assert_equal "test:git@github.com:toshi0383/scripts.git", list_output
  end
end
