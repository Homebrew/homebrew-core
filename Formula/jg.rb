class Jg < Formula
  version '0.1.3'
  desc "A command-line JSON processor in Rust. jg searches for selector patterns in json input, jg prints each json object that matches a pattern."
  homepage "https://github.com/gmmorris/jg"

  if OS.mac?
      url "https://github.com/gmmorris/jg/releases/download/#{version}/jg-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "4f36a8cebfd51cf97d99f415910c09e4354f847fde56bdc3e55311872aad0ed9"
  elsif OS.linux?
      url "https://github.com/gmmorris/jg/releases/download/#{version}/jg-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "d10bd0cad1cf5a0e4c8ef26f2d531f41638bde71b6e499555815da88e73a5fa5"
  end

  def install
    bin.install "jg"
  end

  test do
    assert_equal "{\"name\":\"jeff goldblum\"}\n", pipe_output("#{bin}/jg .name", '{"name":"jeff goldblum"}')
  end
end
