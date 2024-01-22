class Llamafile < Formula
  desc "Distribute and run LLMs with a single file"
  homepage "https://github.com/Mozilla-Ocho/llamafile"
  url "https://github.com/Mozilla-Ocho/llamafile/archive/refs/tags/0.6.1.tar.gz"
  sha256 "553eea3faecde2f6e52b42ec719c5f2129832f3337b1bc9c5f8e9a449a694f46"
  license "Apache-2.0"
  head "https://github.com/Mozilla-Ocho/llamafile.git", branch: "main"

  depends_on "make"

  skip_clean "bin/llamafile",
             "bin/llamafile-perplexity",
             "bin/llamafile-quantize",
             "bin/llava-quantize",
             "bin/zipalign"

  resource("mistral.gguf") do
    url "https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q4_K_M.gguf"
    sha256 "14466f9d658bf4a79f96c3f3f22759707c291cac4e62fea625e80c7d32169991"
  end

  def install
    ENV.prepend_path "PATH", pwd

    # Call `make` as `gmake` to use GNU `make` on OSX
    make = OS.mac? ? "gmake" : "make"

    system make
    system make, "install", "PREFIX=#{prefix}"
  end

  test do
    resource("mistral.gguf").stage do
      test_cmd = <<~CMD
        #{bin}/llamafile \
                   --model mistral-7b-instruct-v0.1.Q4_K_M.gguf \
                   --cli \
                   --temp 0.0 \
                   --n-predict 1 \
                   --prompt '[INST]Are you working? Be optimistic.[/INST]' \
                   --grammar 'root ::= "yes" | "no"'
      CMD
      assert_match "yes", shell_output(test_cmd)
    end
  end
end
