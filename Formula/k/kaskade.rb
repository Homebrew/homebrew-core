class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https://github.com/sauljabin/kaskade"
  url "https://files.pythonhosted.org/packages/14/7b/fa38da904d8e4b83ad5d957907629f382c3cae929318cb829c18bbdd964f/kaskade-2.3.7.tar.gz"
  sha256 "15ba36c466cdaef95065fe2f7ac60ff699891429ad2ea0769656998efce6de04"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "69e955d1729575110dc996a9ad21a00f24910dd163303219195815a16fc1dd1b"
    sha256 cellar: :any,                 arm64_sonoma:  "aa50063a5eea90b36402e75803b706e0832fffb020edf2aa96f96ae876e88e48"
    sha256 cellar: :any,                 arm64_ventura: "b37bcd00949c927b96cd53eb53e4b917dcc849d6534f40e878f83ca7a8bf52ad"
    sha256 cellar: :any,                 sonoma:        "8c72fd38ca9787248573cedb92acb38d40f474b7b1a3cc5d3a14ca86f943c2db"
    sha256 cellar: :any,                 ventura:       "5afc27780982ced40c0d1da97dd591c48cbae1cbd4624229596e3b9efc6c51f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5baa42b3b0351b8f6d0b78f7dfdc4053be18733248e79747a28d4022935269d7"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "librdkafka"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "avro" do
    url "https://files.pythonhosted.org/packages/e6/73/48668732bbc8ae1e79b237f84e761204c8dd266c5e16e7601000aba471d3/avro-1.12.0.tar.gz"
    sha256 "cad9c53b23ceed699c7af6bddced42e2c572fd6b408c257a7d4fc4e8cf2e2d6b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cloup" do
    url "https://files.pythonhosted.org/packages/cf/71/608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78/cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
  end

  resource "confluent-kafka" do
    url "https://files.pythonhosted.org/packages/cf/b0/164b7e8afb80bf5ff7fc25f793b37f6e5cc118d05fbd6b5e6d4a484a7634/confluent-kafka-2.6.0.tar.gz"
    sha256 "f7afe69639bd2ab15404dd46a76e06213342a23cb5642d873342847cb2198c87"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/11/56/72dc3fa6985c7f27b392cd3991c466eb61208f3c6cb7fc2f12e6bfc6f774/fastavro-1.9.7.tar.gz"
    sha256 "13e11c6cb28626da85290933027cd419ce3f9ab8e45410ef24ce6b89d20a1f6c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/19/03/a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fd/mdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/ce/3a/5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95ca/pyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/aa/9e/1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95/rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/cf/0b/58ec0dbcd92a5121fdae972f09de71b5bc38d389bab53a638e24349f904d/textual-0.83.0.tar.gz"
    sha256 "fc3b97796092d9c7e685e5392f38f3eb2007ffe1b3b1384dee6d3f10d256babd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/kaskade admin -b localhost:9092")
    assert_match "\e[?1049h\e[?1000h\e[?1003h\e[?1015h\e[?1006h\e[?25l", r.readline

    assert_match version.to_s, shell_output("#{bin}/kaskade --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
