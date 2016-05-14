class Conan < Formula
  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://pypi.python.org/packages/0b/34/5b03ad307911ef4221dd965a8867502dc96107cf58ed83f3274421e6808d/conan-0.9.2.tar.gz"
  sha256 "750cef39e504d6d1e267a4fd6fc42ff4d9f4a3a25bbe3dfdbdff573025932db0"

  bottle do
    cellar :any_skip_relocation
    sha256 "19429d91da1d79fb1021a2e7a663603eff4286f495e3700e9014219aede6b3a5" => :el_capitan
    sha256 "4a4a219f12eca63bfb3b6238ba1718508454109354eff31f332664f7dee47507" => :yosemite
    sha256 "aae8d317e2e9add74d893d0183c3f93539f98b81f59f67bed1d1f2a9466198bd" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "boto" do
    url "https://pypi.python.org/packages/e5/6e/13022066f104f6097a7414763c5658d68081ad0bc2b0630a83cd498a6f22/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "bottle" do
    url "https://pypi.python.org/packages/d2/59/e61e3dc47ed47d34f9813be6d65462acaaba9c6c50ec863db74101fa8757/bottle-0.12.9.tar.gz"
    sha256 "fe0a24b59385596d02df7ae7845fe7d7135eea73799d03348aeb9f3771500051"
  end

  resource "cfgparse" do
    url "https://pypi.python.org/packages/a0/37/0f455f3830855c635af9f7dd23d317315712bfbc5daf63abfd18d96fa613/cfgparse-1.3.zip"
    sha256 "adc830323e4d9872af1a81364dd18e958b5550c3cc2d1f05929ec2634147f2f9"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "fasteners" do
    url "https://pypi.python.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/3f/3b/7ee821b1314fbf35e6f5d50fce1b853764661a7f59e2da1cb58d33c3fdd9/monotonic-1.1.tar.gz"
    sha256 "255c31929e1a01acac4ca709f95bd6d319d6112db3ba170d1fe945a6befe6942"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/1e/59/d1a50836b29c87a1bde9442e1846aa11e1548491cbee719e51b45a623e75/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "patch" do
    url "https://pypi.python.org/packages/da/74/0815f03c82f4dc738e2bfc5f8966f682bebcc809f30c8e306e6cc7156a99/patch-1.16.zip"
    sha256 "c62073f356cff054c8ac24496f1a3d7cfa137835c31e9af39a9f5292fd75bd9f"
  end

  resource "PyJWT" do
    url "https://pypi.python.org/packages/55/88/88d9590195a7fcc947501806f79c0918d8d3cdc6f519225d4efaaf3965e8/PyJWT-1.4.0.tar.gz"
    sha256 "e1b2386cfad541445b1d43e480b02ca37ec57259fd1a23e79415b57ba5d8a694"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[boto bottle cfgparse colorama fasteners monotonic passlib patch PyJWT PyYAML requests six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/conan", "install", "zlib/1.2.8@lasote/stable"
  end
end
