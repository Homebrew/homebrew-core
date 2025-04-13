class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.2.2.tar.gz"
  sha256 "1d892bbf3f8dacd0f528f683ab6c3678483374b17076187da7d1af805326fa68"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533cdeef8a749ee8ec433e30f10d4ae6ac7f34de8c4bcdf4c058946c6858b215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "533cdeef8a749ee8ec433e30f10d4ae6ac7f34de8c4bcdf4c058946c6858b215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "533cdeef8a749ee8ec433e30f10d4ae6ac7f34de8c4bcdf4c058946c6858b215"
    sha256 cellar: :any_skip_relocation, sonoma:        "6838fe3e3dd5698d49e3f8b60f41f513330306b10ad5b63cf45591a3a777d21c"
    sha256 cellar: :any_skip_relocation, ventura:       "6838fe3e3dd5698d49e3f8b60f41f513330306b10ad5b63cf45591a3a777d21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0101375d0a74afc9480a58a61334da99dadc13d02b9de4e99ebb2ea236e20665"
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
