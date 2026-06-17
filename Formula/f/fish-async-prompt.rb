class FishAsyncPrompt < Formula
  desc "Make your prompt asynchronous to improve the reactivity"
  homepage "https://github.com/acomagu/fish-async-prompt"
  url "https://github.com/acomagu/fish-async-prompt/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b6baf0f756b301d13ad3cad065b783d0c4d14aee9f8cc6c1b25b28fb485bc1f6"
  license "MIT"

  depends_on "fish"

  def install
    fish_function.install "conf.d/__async_prompt.fish"
  end

  test do
    assert_match "__async_prompt", shell_output("fish -c 'functions -a'")
  end
end
