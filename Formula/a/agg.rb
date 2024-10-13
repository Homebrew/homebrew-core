class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "1089e47a8e6ca7f147f74b2347e6b29d94311530a8b817c2f30f19744e4549c1"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "469e124d131575a7e6b2093071ac6a53dfa5f05bc515e7b19184238a7766ae0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d6b036fd0f03ff84ffe83d09e0a660d4bd79ce2ecfe2e4799a5815c62f24993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cdddd59d396fa79de8e0245a5d49d77f1866f65b6c0546b56a5806348e6e8af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7031d93662fa36539366dc8c6fa43a19d96365c71257f5fc659e36e09b5dbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f257b17848d6242e2b70abc34e7ae2f8dec2899a1128664aa275949c1288b039"
    sha256 cellar: :any_skip_relocation, ventura:        "81706925232634ce3f06924087a946f89d6a4b426c86c094f85359a48e4bb5e9"
    sha256 cellar: :any_skip_relocation, monterey:       "2835eb5b345dfd0f27d295edb5c1b145f25d7b5ffe5e8b37805f376ec7fcdbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "533f37508e544b5a69d86670489f2b541fdf34b203dbfdee0256843b58193556"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\u001b[1;31mHello \u001b[32mWorld!\u001b[0m\n"]
      [1.001376, "o", "That was ok\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_predicate testpath/"test.gif", :exist?
  end
end
