class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c5ef26dce4bd02e479ea2d06cae4220389ba8c37834094d18036bf86efc413ab"
  license "BSD-2-Clause"
  head "https://github.com/ponylang/corral.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "221d04033f0fef8e01fb27171c2c550d53da9af7c7db28cfff28663353767473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfa6dcbf33c7b6ceca2da4426bcab5f7ce247db2685e6c9bbd54320893be64a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b46b87aeb4a7b8016a4193d6e2341d525bab958c534a7a047c33bffe65ab9382"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c290b9d9092b36541df54cdbe031e3e7341066161c18d0adc21d13aa353cc52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e05a2c9941781bbef640cefbb4777cd70531c58d40f23b53385401b9ce697c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4f40bb40dc2f78b05f677cec8bea8e7a27d8f08cfe17b3f703cb57b5f65adc"
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~PONY
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    PONY
    system bin/"corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
