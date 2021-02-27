class Bottom < Formula
  desc "Graphical process/system monitor"
  homepage "https://github.com/ClementTsang/bottom"
  url "https://github.com/ClementTsang/bottom/archive/0.5.7.tar.gz"
  sha256 "49e01a2930d913dba2a1329389faddb4b3971a6b0c08f7482d2759475d5cc27c"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    target_dir = `ls #{buildpath}/target/release/build/bottom-*/out/btm.bash | head -n1 | xargs dirname`
    bash_completion.install "#{target_dir}/btm.bash" => "btm"
    zsh_completion.install  "#{target_dir}/_btm"     => "_btm"
    fish_completion.install "#{target_dir}/btm.fish" => "btm.fish"
  end

  test do
    (testpath/"toml_mismatch_type.toml").write <<~EOS
      [flags]
      temperature_type = "k"
      temperature_type = "f"
      temperature_type = "c"
    EOS
    output = shell_output "#{bin}/btm -C #{testpath}/toml_mismatch_type.toml"

    assert_match "invalid type", output
  end
end
