class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https://github.com/sigoden/argc"
  url "https://github.com/sigoden/argc/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "d3eb85faf26a69c582dcea6d0fc2025bcfeec1dd0b9b35384a67059c2833103c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd87f048d0c58c25a09af13aef7f6b61f922d312298bb71fd62b7a9ed922b88b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a5733acc21f8146c6cb3d6dd23968d3d77d4ce3c501b391c50d6cf44556a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17c17e8c931f998b2da7cd5d93365097716a332d1028786c28bf50ff815e4ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "318fd0396e6396ec672e0b302630fccf146564948d1f1cd21bc340954fc33904"
    sha256 cellar: :any_skip_relocation, sonoma:        "50fe3f4adf05485dd7491edf7557457ad160bff95db98d4eb428af060b6254e7"
    sha256 cellar: :any_skip_relocation, ventura:       "46274957c0ee5d3974c6e4aa4a953d16bfb318638935cdd0dc130bf4b89843ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4195f0d5d08d008ad7a470641d8a8246e737ee42395e5915dcf78272db830b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf572063a6a97cf2f9a663c93133e5467b7b06f37c233d0623dc9f8079bc7bd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"argc", "--argc-completions")
  end

  test do
    system bin/"argc", "--argc-create", "build"
    assert_path_exists testpath/"Argcfile.sh"
    assert_match "build", shell_output("#{bin}/argc build")
  end
end
