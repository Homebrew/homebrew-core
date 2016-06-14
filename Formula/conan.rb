class Conan < Formula
  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://pypi.python.org/packages/27/47/9098ac3ad4416c5a2ecb6bfbd45dd65e59c01a1f1281493c737a95245ce2/conan-0.9.4.tar.gz"
  sha256 "deb686194e77e4c12b8b56caf6da9abf6bc510987cb2b06c939c145aaffa4c87"

  bottle do
    cellar :any_skip_relocation
    sha256 "19429d91da1d79fb1021a2e7a663603eff4286f495e3700e9014219aede6b3a5" => :el_capitan
    sha256 "4a4a219f12eca63bfb3b6238ba1718508454109354eff31f332664f7dee47507" => :yosemite
    sha256 "aae8d317e2e9add74d893d0183c3f93539f98b81f59f67bed1d1f2a9466198bd" => :mavericks
  end

  depends_on :python
  depends_on "openssl"

  resource "backport_ipaddress" do
    url "https://pypi.python.org/packages/d3/30/54c6dab05a4dec44db25ff309f1fbb6b7a8bde3f2bade38bb9da67bbab8f/backport_ipaddress-0.1.tar.gz"
    sha256 "860e338c08e2e9d998ed8434e944af9780e2baa337d1544cc26c9b1763b7735c"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/e5/6e/13022066f104f6097a7414763c5658d68081ad0bc2b0630a83cd498a6f22/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  resource "bottle" do
    url "https://pypi.python.org/packages/d2/59/e61e3dc47ed47d34f9813be6d65462acaaba9c6c50ec863db74101fa8757/bottle-0.12.9.tar.gz"
    sha256 "fe0a24b59385596d02df7ae7845fe7d7135eea73799d03348aeb9f3771500051"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/b6/98/11feff87072e2e640fb8320712b781eccdef05d588618915236b32289d5a/cffi-1.6.0.tar.gz"
    sha256 "a7f75c4ef2362c0a0e54657add0a6c509fecbfa3b3807bc0925f5cb1c9f927db"
  end

  resource "cfgparse" do
    url "https://pypi.python.org/packages/a0/37/0f455f3830855c635af9f7dd23d317315712bfbc5daf63abfd18d96fa613/cfgparse-1.3.zip"
    sha256 "adc830323e4d9872af1a81364dd18e958b5550c3cc2d1f05929ec2634147f2f9"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/a9/5b/a383b3a778609fe8177bd51307b5ebeee369b353550675353f46cb99c6f0/cryptography-1.4.tar.gz"
    sha256 "bb149540ed90c4b2171bf694fe6991d6331bc149ae623c8ff419324f4222d128"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "fasteners" do
    url "https://pypi.python.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "monotonic" do
    url "https://pypi.python.org/packages/3f/3b/7ee821b1314fbf35e6f5d50fce1b853764661a7f59e2da1cb58d33c3fdd9/monotonic-1.1.tar.gz"
    sha256 "255c31929e1a01acac4ca709f95bd6d319d6112db3ba170d1fe945a6befe6942"
  end

  resource "ndg-httpsclient" do
    url "https://pypi.python.org/packages/08/92/6318c6c71566778782065736d73c62e621a7a190f9bb472a23857d97f823/ndg_httpsclient-0.4.1.tar.gz"
    sha256 "133931ab2cf7118f8fc7ccc29e289ba8f644dd90f84632fa0e6eb16df4ba1891"
  end

  resource "passlib" do
    url "https://pypi.python.org/packages/1e/59/d1a50836b29c87a1bde9442e1846aa11e1548491cbee719e51b45a623e75/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "patch" do
    url "https://pypi.python.org/packages/da/74/0815f03c82f4dc738e2bfc5f8966f682bebcc809f30c8e306e6cc7156a99/patch-1.16.zip"
    sha256 "c62073f356cff054c8ac24496f1a3d7cfa137835c31e9af39a9f5292fd75bd9f"
  end

  resource "pyasn" do
    url "https://pypi.python.org/packages/59/19/c27c3cd9506de02f90cf2316d922e067f6abd487cf7ef166ea91962ddc88/pyasn-1.5.0b7.tar.gz"
    sha256 "361ec1ae958c6bcd88653febbe35b2d0961f0b891ed988544327c0ae308bd521"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/18/e2/32e2457514b32ded24f2ebecfca3866ce08203e8cfeec18f9535f14ef374/pycparser-2.10.tar.gz"
    sha256 "957d98b661c0b64b580ab6f94b125e09b6714154ee51de40bca16d3f0076b86c"
  end

  resource "PyJWT" do
    url "https://pypi.python.org/packages/55/88/88d9590195a7fcc947501806f79c0918d8d3cdc6f519225d4efaaf3965e8/PyJWT-1.4.0.tar.gz"
    sha256 "e1b2386cfad541445b1d43e480b02ca37ec57259fd1a23e79415b57ba5d8a694"
  end

  resource "pyOpenSSL" do
    url "https://pypi.python.org/packages/77/f2/bccec75ca4280a9fa762a90a1b8b152a22eac5d9c726d7da1fcbfe0a20e6/pyOpenSSL-16.0.0.tar.gz"
    sha256 "363d10ee43d062285facf4e465f4f5163f9f702f9134f0a5896f134cbb92d17d"
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
    resources.each do |r|
      r.stage do
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
