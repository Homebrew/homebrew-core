class Hexhog < Formula
  desc "Hex viewer/editor"
  homepage "https://github.com/DVDTSB/hexhog"
  url "https://github.com/DVDTSB/hexhog/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "5858dcb32b3f12647784c9a6ba2e107e157b9a82884bcfed3e994a70c7584b29"
  license "MIT"
  head "https://github.com/DVDTSB/hexhog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde40a9e189b6f6be35e4ba2898a82d45e254d1189fc9e3f73e4342d91b09d8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "935652feeff33ebcd7ae3e5cb78b48d8090dd530d1ed2b08c2ffcbd28fcf5a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b2eb1a539e108f115bf83759ca462e975cd4acf0489ae71bd6ab777ffdcc2b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "138dace07719c079ca390a4b4c88c69be559c818059582b2f08198f73f138e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c6c0e9270acf11f12ba6c94e3e113de6bc1ac22a433afdf89563e7d99ecc592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e76097f40c985fb9c842e70d9c67055f8bca05912e3211967849a897a58e3b63"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hexhog --version")

    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"

      (testpath/"testfile").write("Hello, Hexhog!")
      pid = spawn bin/"hexhog", testpath/"testfile", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "hexhog", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
